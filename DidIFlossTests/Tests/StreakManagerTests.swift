//
//  StreakManagerTests.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 20/02/24.
//

import XCTest
@testable import DidIFloss

final class StreakManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasNoLogs() {
        
        let logs: [Date] = []
        
        let result = StreakManager.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.state, StreakInfo.State.empty)
        
        
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasFlossStreakButDidntFlossToday() {
        
        let logs: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -3, to: Date())!]
        
        let result = StreakManager.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.state, StreakInfo.State.missingToday)
        XCTAssertEqual(result.days, 3)
        
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasCompleteFlossStreak() {
        let logs: [Date] = [Date(),
                            Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -3, to: Date())!]
        
        let result = StreakManager.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.state, StreakInfo.State.streak)
        XCTAssertEqual(result.days, 4)
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasMissingFlossStreak() {
        
        let logs: [Date] = [Calendar.current.date(byAdding: .day, value: -3, to: Date())!]
        
        let result = StreakManager.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.state, StreakInfo.State.missing)
        XCTAssertEqual(result.days, 3)
        
        
    }
}
