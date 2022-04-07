//
//  ContentView.swift
//  UITableViewInSheet
//
//  Created by Maksim Bezdrobnoi on 07.04.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.clear
                .sheet(isPresented: .constant(true)) {
                    AwesomeNewTable {
                        Button(action: {
                            print("HELLO")
                        }, label: {
                            Color.red
                                .frame(height: 30)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 4)
                        })
                    }
                }
        }
    }
}

struct AwesomeNewTable<Content: View>: UIViewRepresentable {
    
    private let content: () -> Content
    
    init(content: @escaping () -> Content) {
        self.content = content
    }
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.register(HostingCell<Content>.self, forCellReuseIdentifier: "Cell")
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.parent = self
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        
        var parent: AwesomeNewTable
        
        init(parent: AwesomeNewTable) {
            self.parent = parent
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            50
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HostingCell<Content> else {
                    return UITableViewCell()
                }
            let view = parent.content()
                tableViewCell.setup(with: view)
                return tableViewCell
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


private class HostingCell<Content: View>: UITableViewCell {
    var host: UIHostingController<Content>?

    func setup(with view: Content) {
        if host == nil {
            let controller = UIHostingController(rootView: view)
            host = controller

            guard let content = controller.view else { return }
            content.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(content)

            content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        } else {
            host?.rootView = view
        }

        setNeedsLayout()
    }
}
