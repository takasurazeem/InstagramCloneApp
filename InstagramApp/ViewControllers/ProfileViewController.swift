//
//  ProfileViewController.swift
//  InstagramApp
//
//  Created by Gwinyai on 17/10/2018.
//  Copyright © 2018 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImage

enum ProfileType {

    case personal, otherUser

}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = [Post]()
    var profileType: ProfileType = .personal
    var user: UserModel?

    let imagePicker = UIImagePickerController()

    let progressIndicator: UIProgressView = {
        let progressIndicator = UIProgressView()
        progressIndicator.trackTintColor = .lightGray
        progressIndicator.progressTintColor = .black
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.progress = 0.0
        return progressIndicator
    }()

    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel Upload", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelUpload), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()

    var uploadTask: StorageUploadTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegates
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self

        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        setupProgressIndicator()
        loadData()
    }

    // FIXME: - Add me in my controller later please.
    fileprivate func reloadProfileHeader() {
        self.tableView.reloadSections(IndexSet(integer: IndexSet.Element(0)), with: .automatic)
    }

    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else { Helper.logout(); return }
        let userRef = UserModel.collection.document(userId)
        // TODO: - Have second thoughts on having a spinner here for loading or use skeleton view.
        userRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            guard let user = UserModel(data) else { return }
            self.user = user
            DispatchQueue.main.async {
                self.reloadProfileHeader()
            }
        }
    }

    fileprivate func hideProgressVeiw() {
        progressIndicator.isHidden = true
        cancelButton.isHidden = true
    }

    @objc func cancelUpload() {
        hideProgressVeiw()
        uploadTask?.cancel()
    }

    fileprivate func showProgressIndicator() {
        progressIndicator.isHidden = false
        cancelButton.isHidden = false
        progressIndicator.progress = 0
    }

    func uploadImage(data: Data) {
        if let user = Auth.auth().currentUser {
            showProgressIndicator()
            let imageId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
            let imageName = "\(imageId).jpg"
            let pathToPic = "images/\(user.uid)/\(imageName)"
            let storageRef = Storage.storage().reference(withPath: pathToPic)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            uploadTask = storageRef.putData(data, metadata: metaData) { [weak self] _, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.hideProgressVeiw()
                }
                if let error = error {
                    debugPrint(error.localizedDescription)
                    let alert = Helper.errorAlert(title: "Upload Error", message: "There was a problem uploading the image")
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                } else {
                    // Download the URL
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        }
                        // Image successfully uploaded
                        UserModel.collection.document(user.uid).updateData(["profileImage": url?.absoluteString ?? ""])
                        self.reloadProfileHeader()
                    }

                }
            }
            uploadTask?.observe(StorageTaskStatus.progress) { [weak self] snapshot in
                guard let self = self else { return }
                let percentComplete = 100 * (Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount))
                DispatchQueue.main.async {
                    self.progressIndicator.setProgress(Float(percentComplete), animated: true)
                }
            }
            //            uploadTask?.resume()
        }
    }

    fileprivate func setupProgressIndicator() {
        hideProgressVeiw()

        view.addSubview(progressIndicator)
        view.addSubview(cancelButton)

        let constraints: [NSLayoutConstraint] = [
            // Progress Indicator Constaints
            progressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            progressIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            progressIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // Cancel Button Constraints
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            cancelButton.topAnchor.constraint(equalTo: progressIndicator.bottomAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 3

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {

            return 1

        } else if section == 1 {

            return 1

        } else {

            return posts.count

        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let profileHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
            profileHeaderTableViewCell.profileType = profileType
            profileHeaderTableViewCell.delegate = self
            if let user = user {
                profileHeaderTableViewCell.nameLabel.text = user.username
                // Cancel any image load.
                profileHeaderTableViewCell.profileImageView.sd_cancelCurrentImageLoad()
                // Load the correct image
                profileHeaderTableViewCell.profileImageView.sd_setImage(with: user.profileImage, completed: nil)
            }

            switch profileType {

            case .otherUser:

                profileHeaderTableViewCell.profileButton.setTitle("Follow", for: .normal)

            case .personal:

                profileHeaderTableViewCell.profileButton.setTitle("Logout", for: .normal)

                profileHeaderTableViewCell.profileButton.setTitleColor(UIColor.red, for: .normal)

            }

            return profileHeaderTableViewCell

        } else if indexPath.section == 1 {

            let profileViewStyleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewStyleTableViewCell") as! ProfileViewStyleTableViewCell

            return profileViewStyleTableViewCell

        } else if indexPath.section == 2 {

            let feedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell

            return feedTableViewCell

        } else {

            return UITableViewCell()

        }

    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
           let resizedImage = pickedImage.resized(toWidth: 1080),
           let imageData = resizedImage.jpegData(compressionQuality: 0.75) {
            uploadImage(data: imageData)
        }
        dismiss(animated: true)
    }
}

extension ProfileViewController: ProfileHeaderDelegate {
    func profileImageDidTouch() {
        self.imagePicker.allowsEditing = true
        let alertController = UIAlertController(title: "Change Profile", message: "Choose an option", preferredStyle: .actionSheet)
        let libraryOption = UIAlertAction(title: "Import from Library", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let takePhotoOption = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cancelOption = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        // TODO: - Add an option to remove the current photo.
        alertController.addAction(libraryOption)
        alertController.addAction(takePhotoOption)
        alertController.addAction(cancelOption)
        present(alertController, animated: true, completion: nil)
    }
}
