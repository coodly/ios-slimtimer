/*
* Copyright 2015 Coodly LLC
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import SWLogger

@objc class LogCaller: NSObject {
    static func setUp() {
        Logger.sharedInstance.setLogLevel(Log.Level.DEBUG)
        Logger.sharedInstance.addOutput(ConsoleOutput())
        Logger.sharedInstance.addOutput(FileOutput())
    }
    
    static func startSession() {
        
    }
    
    static func info(message:String) {
        Log.info(message);
    }
    
    static func shakeWindow() -> UIWindow {
        return ShakeWindow(frame: UIScreen.mainScreen().bounds)
    }
}