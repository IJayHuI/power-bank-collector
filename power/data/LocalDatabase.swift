//
//  LocalDatabase.swift
//  power
//
//  Created by HUAWEI MateBook X on 2025/6/30.
//

import Foundation
import SQLite

class LocalDatabase {
    static let shared = LocalDatabase()
    
    private var db: Connection?
    
    let items = Table("items")
    
    let id = Expression<Int64>("id")
    let itemid = Expression<Int>("itemid")
    let documentId = Expression<String>("documentId")
    let date = Expression<String>("date")
    let powerstatus = Expression<Int>("powerstatus")
    let powerdate = Expression<String>("powerdate")
    let image = Expression<String>("image")
    let name = Expression<String>("name")
    
    private init() {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = url.appendingPathComponent("power.sqlite3")

        // 先删除旧数据库文件（调试用，运行后注释或删除）
        if fileManager.fileExists(atPath: dbPath.path) {
            do {
                try fileManager.removeItem(at: dbPath)
                print("旧数据库文件已删除")
            } catch {
                print("删除旧数据库文件失败：\(error.localizedDescription)")
            }
        }

        do {
            db = try Connection(dbPath.path)
            try createTable()
            print("数据库初始化成功")
        } catch {
            print("数据库连接失败: \(error.localizedDescription)")
        }
    }
    
    private func createTable() throws {
        try db?.run(items.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(itemid)
            t.column(documentId)
            t.column(date)
            t.column(powerstatus)
            t.column(powerdate)
            t.column(image)
            t.column(name)
        })
        print("表 items 创建成功")
    }
    
    func insertItem(deviceId: Int, documentId: String, dateStr: String, status: Int, powerDate: String, imageUrl: String, name: String) throws {
        guard let db = db else {
            throw NSError(domain: "数据库未初始化", code: 0)
        }
        
        let insert = items.insert(
            itemid <- deviceId,
            self.documentId <- documentId, 
            date <- dateStr,
            powerstatus <- status,
            powerdate <- powerDate,
            image <- imageUrl,
            self.name <- name
        )
        
        try db.run(insert)
    }
    
    func fetchOwnedItems() throws -> [OwnedItem] {
        guard let db = db else {
            throw NSError(domain: "数据库未初始化", code: 0)
        }
        var result: [OwnedItem] = []
        let query = items.filter(powerstatus == 1)
        for row in try db.prepare(query) {
            let item = OwnedItem(
                id: row[id],
                itemid: row[itemid],
                date: row[date],
                powerstatus: row[powerstatus],
                powerdate: row[powerdate],
                image: row[image],
                name: row[name],
                documentId: row[documentId]
            )
            result.append(item)
        }
        return result
    }
    func fetchWishItems() throws -> [OwnedItem] {
        guard let db = db else {
            throw NSError(domain: "数据库未初始化", code: 0)
        }
        var result: [OwnedItem] = []
        let query = items.filter(powerstatus == 2)  // powerstatus == 2 代表愿望状态
        for row in try db.prepare(query) {
            let item = OwnedItem(
                id: row[id],
                itemid: row[itemid],
                date: row[date],
                powerstatus: row[powerstatus],
                powerdate: row[powerdate],
                image: row[image],
                name: row[name],
                documentId: row[documentId]
            )
            result.append(item)
        }
        return result
    }
    func updatePowerDate(documentId: String, newDate: String) throws {
        guard let db = db else {
            throw NSError(domain: "数据库未初始化", code: 0)
        }

        let target = items.filter(self.documentId == documentId && powerstatus == 1)
        try db.run(target.update(powerdate <- newDate))
    }
    
    func countItems(withStatus status: Int) -> Int {
        guard let db = db else { return 0 }
        do {
            let query = items.filter(powerstatus == status)
            return try db.scalar(query.count)
        } catch {
            print("统计失败: \(error.localizedDescription)")
            return 0
        }
    }
    
    
    func fetchMaintenanceItems() throws -> [MaintenanceItem] {
        guard let db = db else {
            throw NSError(domain: "数据库未初始化", code: 0)
        }
        var result: [MaintenanceItem] = []
        let query = items.filter(powerstatus == 3)  // powerstatus = 3 表示需维护
        for row in try db.prepare(query) {
            let item = MaintenanceItem(
                id: row[id],
                itemid: row[itemid],
                documentId: row[documentId],
                name: row[name],
                date: row[date],
                image: row[image]
            )
            result.append(item)
        }
        return result
    }
}
