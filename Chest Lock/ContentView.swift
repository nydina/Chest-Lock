import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isAppLocked = true
    
    var body: some View {
        VStack {
            Text(isAppLocked ? "Application locked" : "Application unlocked")
            ZStack {
                Circle().frame(maxWidth: 135).foregroundColor(isAppLocked ? .red : .green)
                Circle().frame(maxWidth: 130).foregroundColor(.white)
                Image(systemName: isAppLocked ? "lock" :"lock.open").font(.largeTitle)
            }
            
            Button(action: {
                if isAppLocked {
                    authenticate()
                } else {
                    isAppLocked = true
                }
            }) {
                Text(isAppLocked ? "Open" : "Lock")
                    .padding()
                    .foregroundColor(.white)
            }
            .background(isAppLocked ? Color.green : Color.red)
            .cornerRadius(6)
            .padding()
        }
    }

    func authenticate() {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to unlock the app"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful, unlock the app
                        isAppLocked = false
                    } else {
                        print("Authentication failed")
                    }
                }
            }
        } else {
            print("Biometric authentication not available")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
