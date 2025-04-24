//
//  EmojiPickerView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/20/25.
//

import SwiftUI
import ElegantEmojiPicker

struct EmojiPickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onEmojiSelected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ElegantEmojiPicker {
        let picker = ElegantEmojiPicker(delegate: context.coordinator)
        return picker
    }

    func updateUIViewController(_ uiViewController: ElegantEmojiPicker, context: Context) {}

    class Coordinator: NSObject, ElegantEmojiPickerDelegate {
        var parent: EmojiPickerView

        init(_ parent: EmojiPickerView) {
            self.parent = parent
        }

        func emojiPicker(_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?) {
            if let emoji = emoji?.emoji {
                parent.onEmojiSelected(emoji)
            }
        }
    }
}
