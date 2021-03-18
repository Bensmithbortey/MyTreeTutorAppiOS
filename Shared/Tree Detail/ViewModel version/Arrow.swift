////
////  Arrow.swift
////  MyTreeTutorApp (iOS)
////
////  Created by Benjamin-Smith Bortey on 18/03/2021.
////
//
//import SwiftUI
//
//struct Arrow: Shape {
//
//    enum Direction {
//        case upLeft, upRight, downLeft, downRight
//    }
//
//    let direction: Direction
//
//    func path(in rect: CGRect) -> Path {
//
//        let width = rect.width / 2
//        let height = rect.height
//
//        return Path { path in
//
//            switch self.direction {
//            case .upLeft:
//                path.addLines([
//                    CGPoint(x: width, y: height),
//                    CGPoint(x: 0, y: 0)
//                ])
//            case .upRight:
//                path.addLines([
//                    CGPoint(x: 0, y: height),
//                    CGPoint(x: width, y: 0)
//                ])
//            case .downLeft:
//                path.addLines([
//                    CGPoint(x: width, y: 0),
//                    CGPoint(x: width, y: height)
//                ])
//            case .downRight:
//                path.addLines([
//                    CGPoint(x: 0, y: 0),
//                    CGPoint(x: width, y: height)
//                ])
//            }
//
//            path.closeSubpath()
//        }
//
//    }
//
//}
//
//struct Arrow_Previews: PreviewProvider {
//    static var previews: some View {
//        Arrow(direction: .upLeft)
//            .stroke()
//            .foregroundColor(.blue)
//            .frame(width: 200, height: 200)
//    }
//}
