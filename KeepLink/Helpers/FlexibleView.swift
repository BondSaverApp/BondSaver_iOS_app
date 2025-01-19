//
//  FlexibleView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 19.01.2025.
//

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(
        data: Data,
        spacing: CGFloat = 8,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            let maxWidth = geometry.size.width
            VStack(alignment: alignment, spacing: spacing) {
                ForEach(groupItems(maxWidth: maxWidth), id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(row, id: \.self) { item in
                            content(item)
                        }
                    }
                }
            }
        }
    }

    private func groupItems(maxWidth: CGFloat) -> [[Data.Element]] {
        var rows: [[Data.Element]] = []
        var currentRow: [Data.Element] = []
        var currentWidth: CGFloat = 0

        for item in data {
            let itemWidth = estimateWidth(for: item)

            if currentWidth + itemWidth + spacing > maxWidth {
                rows.append(currentRow)
                currentRow = [item]
                currentWidth = itemWidth
            } else {
                currentRow.append(item)
                currentWidth += itemWidth + spacing
            }
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    private func estimateWidth(for item: Data.Element) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (String(describing: item) as NSString).size(withAttributes: attributes)
        return size.width + 16 // Добавляем отступы
    }
}
