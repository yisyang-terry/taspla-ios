import SwiftUI
import AppCore

struct ValuesView: View {
    @EnvironmentObject var store: AppStore
    @State private var showingAdd = false
    @State private var name = ""
    @State private var desc = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.values) { val in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(val.name).font(.headline)
                        if !val.description.isEmpty {
                            Text(val.description).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Values")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Name", text: $name)
                        TextField("Description", text: $desc, axis: .vertical)
                    }
                    .navigationTitle("New Value")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAdd = false; name = ""; desc = "" }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                store.addValue(name: name, description: desc)
                                showingAdd = false; name = ""; desc = ""
                            }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }
}

struct ValuesView_Previews: PreviewProvider {
    static var previews: some View {
        ValuesView().environmentObject(AppStore())
    }
}
