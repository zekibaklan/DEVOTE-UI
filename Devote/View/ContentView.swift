//
//  ContentView.swift
//  Devote
//
//  Created by Zeki Baklan on 12.09.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //    MARK: - PROPERTY
    @AppStorage("isDarkMode") private var isDarkMode : Bool = false
    @State var task : String = ""
    @State private var showNewTaskItem : Bool = false
    
   
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    //    MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                //    MARK: - MAIN VIEW

                
                
                
                VStack {
                    //    MARK: - HEADER
                    HStack(spacing: 10) {
                       // TITLE
                        Text("Devote")
                            .font(.system(.largeTitle,design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading,4)
                            Spacer()
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal,10)
                            .frame(minWidth: 70,minHeight: 24)
                            .background(Capsule().stroke(Color.white))
                        // APPARENCE BUTTON
                        
                        
                        Button {
                            // TOOGLE APPERANCE
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24,height: 24)
                                .font(.system(.title,design: .rounded))
                        }

                        
                        
                    }//:HSTACK
                    .padding()
                    .foregroundColor(.white)
                    Spacer(minLength: 80)
                    
                    //    MARK: -  NEW TASK BUTTON
                    
                    Button {
                        playSound(sound: "sound-ding", type: "mp3")
                        showNewTaskItem = true
                        
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                           
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical,15)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.pink,Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0.0, y: 4.0)

                    //    MARK: -  TASKS
                
                    List {
                        ForEach(items) { item in
                           ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                        
                        
                        
                        
                        
                    }//:LIST
                    
                    
                    .cornerRadius(20) // 1.
                    .listStyle(.inset) // 2.
                    .padding(20) // 3.
                    // .scrollContentBackground(Color.red) // iOS 16
                    // .scrollContentBackground(Color.clear) // iOS 16
                    // .scrollContentBackground(.hidden) // iOS 16
                    .shadow(color: .black.opacity(0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                }//:VSTACK
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .animation(.easeOut(duration: 0.5))
                .transition(.move(edge: .bottom))
                //   MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }

            }//:ZSTACK
            
            
            
            
                .navigationTitle("Daily Tasks")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarHidden(true)
                .background(
                  BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                )
                .background(backgroundGradient.ignoresSafeArea())
                .background(
                  backgroundGradient.ignoresSafeArea(.all)
                )
    
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }

           
            Text("Select an item")
        } //: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
//    MARK: - FUNCTION
   
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
               
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
        
}//:CONTENT VIEW



//    MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
