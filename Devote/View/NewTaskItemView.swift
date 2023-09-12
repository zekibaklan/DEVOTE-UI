//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Zeki Baklan on 12.09.2023.
//

import SwiftUI

struct NewTaskItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var task : String = ""
    @Binding var isShowing : Bool
    
    private var isButtonDisabled : Bool {
        task.isEmpty
    }
    //    MARK: - FUNCTIOn
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
              
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                TextField("New Task",text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                Button {
                    addItem()
                } label: {
                    Spacer()
                    Text("save".uppercased())
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Spacer()
                     
                }
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(10)

            }//:VSTACK
            
            
            .padding(.horizontal)
            .padding(.vertical,20)
            .background(
                Color.white
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.65), radius: 24)
            .frame(maxWidth: 640)
            
        }//:VSTACK
        .padding()
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
