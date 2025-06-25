import SwiftUI

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var databaseManager: DatabaseManager

    var body: some View {
        TabView {
            Clients()
                .tabItem {
                    Label("Clients", systemImage: "person.3")
                }

            Businesses()
                .tabItem {
                    Label("Businesses", systemImage: "building.2")
                }
        }
        .environmentObject(databaseManager)
    }

    private struct Clients: View {

        @EnvironmentObject private var databaseManager: DatabaseManager

        var body: some View {
            List(databaseManager.clients) { client in
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .bold()
                        Text(client.name)
                    }
                    HStack {
                        Text("Email")
                            .bold()
                        Text(client.email?.email ?? "none")
                    }
                    HStack {
                        Text("Phone")
                            .bold()
                        Text(client.phone ?? "none")
                    }
                    HStack {
                        Text("Address")
                            .bold()
                        Text(client.address ?? "none")
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: databaseManager.clients)
            .safeAreaInset(edge: .bottom) {
                Button("Add client") {
                    databaseManager.createClient(
                        name: .randomName,
                        email: Email(.randomEmail),
                        phone: .randomPhone,
                        address: .randomAddress
                    )
                }
            }
        }
    }

    private struct Businesses: View {

        @EnvironmentObject private var databaseManager: DatabaseManager

        var body: some View {
            List(databaseManager.businesses) { business in
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .bold()
                        Text(business.name)
                    }
                    HStack {
                        Text("Contact Name")
                            .bold()
                        Text(business.contactName ?? "none")
                    }
                    HStack {
                        Text("Email")
                            .bold()
                        Text(business.contactEmail?.email ?? "none")
                    }
                    HStack {
                        Text("Phone")
                            .bold()
                        Text(business.contactPhone ?? "none")
                    }
                    HStack {
                        Text("Address")
                            .bold()
                        Text(business.contactAddress ?? "none")
                    }
                    HStack {
                        Text("Logo")
                            .bold()
                        Text(business.logoURLString ?? "none")
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: databaseManager.businesses)
            .safeAreaInset(edge: .bottom) {
                Button("Add business") {
                    databaseManager.createBusiness(
                        name: .randomName,
                        contactName: .randomName,
                        contactEmail: Email(.randomEmail),
                        contactPhone: .randomPhone,
                        contactAddress: .randomAddress,
                        logoURLString: nil
                    )
                }
            }
        }
    }
}

private extension String {
    static var randomName: String {
        ["Alice", "Bob", "Charlie", "Diana", "Eve"].randomElement()!
    }

    static var randomEmail: String {
        let name = UUID().uuidString.prefix(8)
        return "\(name)@example.com"
    }

    static var randomPhone: String {
        let digits = (0..<9).map { _ in Int.random(in: 0...9) }.map(String.init).joined()
        return "+48 \(digits)"
    }

    static var randomAddress: String {
        let streets = ["Main St", "High St", "Maple Ave", "Park Blvd"]
        let number = Int.random(in: 1...200)
        return "\(streets.randomElement()!) \(number)"
    }
}
