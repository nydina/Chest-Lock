import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isAppLocked = true

    var body: some View {
        VStack {
            if isAppLocked {
                Button("Open") {
                    authenticate()
                }
            } else {
                Button("Lock") {
                    isAppLocked = true
                }
            }
        }
        .padding()
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
