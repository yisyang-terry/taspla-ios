import SwiftUI
import AppCore

struct TaskComposerView: View {
    @EnvironmentObject var store: AppStore
    @State private var selectedGoal: Goal?
    @State private var epicName: String = ""
    @State private var epicDesc: String = ""
    @State private var tasksText: String = ""
    @State private var selectedValue: Value?
    @State private var isLoadingAI = false
    @State private var aiTrigger: Int = 0

    let llm: LLMService = MockLLMService()

    var body: some View {
        NavigationStack {
            Form {
                Picker("Goal", selection: Binding(get: { selectedGoal?.id }, set: { id in selectedGoal = store.goals.first { $0.id == id } })) {
                    Text("None").tag(UUID?.none)
                    ForEach(store.goals) { g in Text(g.name).tag(UUID?.some(g.id)) }
                }
                TextField("Epic name", text: $epicName)
                TextField("Epic description", text: $epicDesc, axis: .vertical)
                Picker("Value", selection: Binding(get: { selectedValue?.id }, set: { id in selectedValue = store.values.first { $0.id == id } })) {
                    Text("None").tag(UUID?.none)
                    ForEach(store.values) { v in Text(v.name).tag(UUID?.some(v.id)) }
                }
                Section("Tasks (one per line)") {
                    TextEditor(text: $tasksText)
                        .frame(minHeight: 120)
                }
                HStack {
                    Button("Generate with AI") { aiTrigger += 1 }
                        .disabled(selectedGoal == nil || isLoadingAI)
                    Spacer()
                    Button("Add") { add() }.disabled(selectedGoal == nil || epicName.isEmpty || tasksText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Composer")
        }
        .task(id: aiTrigger) { await generateWithAI() }
    }

    func add() {
        guard let goal = selectedGoal else { return }
        store.addEpic(goalId: goal.id, name: epicName, description: epicDesc)
        guard let epic = store.epics.last else { return }
        tasksText
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .forEach { line in store.addTask(epicId: epic.id, valueId: selectedValue?.id, name: line, description: "", points: 1) }
        epicName = ""; epicDesc = ""; tasksText = ""; selectedGoal = nil; selectedValue = nil
    }

    func generateWithAI() async {
        guard let goal = selectedGoal else { return }
        isLoadingAI = true
        defer { isLoadingAI = false }
        let suggestions = await llm.suggestEpicsAndTasks(goal: goal, primaryValues: store.values)
        if let first = suggestions.first {
            epicName = first.epicName
            epicDesc = first.epicDescription
            tasksText = first.tasks.map { $0.name }.joined(separator: "\n")
        }
    }
}

struct TaskComposerView_Previews: PreviewProvider { static var previews: some View { TaskComposerView().environmentObject(AppStore()) } }
