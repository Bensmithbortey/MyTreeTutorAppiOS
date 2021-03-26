//
//  BinaryTreeView.swift
//  MyTreeTutorApp (iOS)
//
//  Created by Benjamin-Smith Bortey on 18/03/2021.
//

//import SwiftUI
//
//struct BinaryTreeView: View {
//
//    let tree: BinaryTree
//
//    var body: some View {
//
//        VStack {
//            Text("\(tree.value)")
//                .padding()
//                .background(
//                    Rectangle()
//                        .foregroundColor(tree.selected ? .blue : .gray)
//                )
//                .clipShape(
//                    Circle()
//                )
//                .frame(width: 60, height: 60)
//
//            GeometryReader { geometry  in
//
//                HStack {
//                    VStack(alignment: .leading, spacing: 0) {
//                        if let subtree = tree.left {
//                            Arrow(direction: .downLeft)
//                                .stroke()
//                                .foregroundColor(.black)
//                                .frame(height: 20)
//                            BinaryTreeView(tree: subtree)
//                        } else {
//                            Rectangle()
//                                .foregroundColor(.clear)
//                        }
//                    }.frame(width: geometry.size.width / 2)
//
//                    VStack(alignment: .trailing, spacing: 0) {
//                        if let subtree = tree.right {
//                            Arrow(direction: .downRight)
//                                .stroke()
//                                .foregroundColor(.black)
//                                .frame(height: 20)
//                            BinaryTreeView(tree: subtree)
//                        } else {
//                            Rectangle()
//                                .foregroundColor(.clear)
//                        }
//                    }.frame(width: geometry.size.width / 2)
//                }
//            }
//        }//: VStack
//    }
//}
//
//struct BinaryTreeView_Previews: PreviewProvider {
//    static var previews: some View {
//        BinaryTreeView(tree: BinaryTree(value: 44))
//    }
//}
