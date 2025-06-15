import SwiftUI

struct SectionIndexBar: View {
    let titles: [String]                 // A‑Z, # …
    var onSelection: (String) -> Void    // 回调
    @State private var current: String?  // 正在高亮的字母

    var body: some View {
        GeometryReader { geo in
            let rowHeight: CGFloat = calculatedRowHeight(totalHeight: geo.size.height)

            VStack(spacing: 0) {
                ForEach(titles, id: \.self) { letter in
                    IndexRow(
                        letter: letter,
                        isCurrent: letter == current,
                        rowHeight: rowHeight
                    )
                    .onTapGesture { select(letter) }
                }
            }
            .contentShape(Rectangle())          // 整条区域都响应手势
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in handleDrag(value, rowHeight: rowHeight) }
                    .onEnded { _ in current = nil }
            )
        }
        .frame(width: 20)                       // 固定宽度，外层再拉伸高度
    }

    // MARK: - 拆出纯算法

    private func calculatedRowHeight(totalHeight: CGFloat) -> CGFloat {
        let rows = max(titles.count, 1)
        return totalHeight / CGFloat(rows)
    }

    private func handleDrag(_ value: DragGesture.Value, rowHeight: CGFloat) {
        guard rowHeight > 0 else { return }
        let index = Int(value.location.y / rowHeight)
        let clamped = min(max(index, 0), titles.count - 1)
        select(titles[clamped])
    }

    private func select(_ letter: String) {
        guard current != letter else { return }
        current = letter
        onSelection(letter)
    }
}

// MARK: - 单行字母视图

private struct IndexRow: View {
    let letter: String
    let isCurrent: Bool
    let rowHeight: CGFloat

    var body: some View {
        Text(letter)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(isCurrent ? .white : .blue)
            .frame(maxWidth: .infinity, maxHeight: rowHeight)
            .background(isCurrent ? Color.blue : Color.clear)
            .clipShape(Circle())
    }
}
