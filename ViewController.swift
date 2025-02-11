//
//  ViewController.swift
//  UserNotifications.Prac
//
//  Created by 시모니 on 2/7/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    var myItem: [String] = [] {
        didSet {
            print("값이 변함 -> \(myItem.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = "현재 아이템 갯수: \(String(describing: myItem.count))개"
        checkNotificationPermission()
       
    }
    // 🔹 1. 알림 권한 확인 및 요청 메서드
       func checkNotificationPermission() {
           let center = UNUserNotificationCenter.current()
           center.getNotificationSettings { settings in
               DispatchQueue.main.async {
                   switch settings.authorizationStatus {
                   case .notDetermined:
                       // 권한 요청 (사용자가 허용 또는 거부할 수 있음)
                       self.requestNotificationPermission()
                   case .authorized, .provisional:
                       // 이미 허용된 상태면 알림 등록
                       self.scheduleDailyNotification()
                   case .denied:
                       // 사용자가 거부한 상태 -> 설정에서 변경 필요
                       print("알림 권한이 거부됨")
                   default:
                       break
                   }
               }
           }
       }
    
    // 🔹 2. 알림 권한 요청 메서드
    func requestNotificationPermission() {
            print("requestNotificationPermission() - called")
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    print("알림 권한이 허용됨")
                    DispatchQueue.main.async {
                        self.scheduleDailyNotification()
                    }
                } else {
                    print("알림 권한이 거부됨")
                }
            }
        }
    
    // 🔹 3. 알림 등록 메서드
    func scheduleDailyNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let content = UNMutableNotificationContent()
        let itemCount = myItem.count
        content.title = "아마두"
        content.body = "오늘은 \(itemCount) 개의 일정이 있군요!"
        content.sound = .default

        let request = UNNotificationRequest(identifier: "daily_notification", content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("알림 등록 성공")
            }
        }
    }
    
    // 🔹 4. 일정 변경 시 알림 업데이트
    func updateNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        // 기존 알림 제거
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["daily_notification"])
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let content = UNMutableNotificationContent()
        let itemCount = myItem.count
        content.title = "아마두"
        content.body = "오늘은 \(itemCount)개의 일정이 있군요!"
        content.sound = .default

        let request = UNNotificationRequest(identifier: "daily_notification", content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("알림 업데이트 완료 - 현재 일정 개수: \(itemCount)")
            }
        }
    }

    
    @IBAction func deleteBtn(_ sender: UIButton) {
        print("deleteBtn() - called")
        if !myItem.isEmpty {
            myItem.remove(at: 0)
        }
        let itemCount = myItem.count
        DispatchQueue.main.async {
            self.countLabel.text = "현재 아이템 갯수: \(String(describing: itemCount)) 개"
        }
        updateNotification()
    }
    
    
    @IBAction func addBtn(_ sender: UIButton) {
        print("addBtn() - called")
        let item = "a"
        myItem.append(item)
        let itemCount = myItem.count
        DispatchQueue.main.async {
            self.countLabel.text = "현재 아이템 갯수: \(String(describing: itemCount)) 개"
        }
        updateNotification()
    }
    


}

