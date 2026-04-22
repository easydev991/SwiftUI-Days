import SwiftUI

struct ListItemView: View {
    struct Content {
        let title: String
        let colorTag: Color?
        let daysCount: String

        init(item: Item, currentDate: Date) {
            title = item.title
            colorTag = item.colorTag
            daysCount = item.makeDaysCount(to: currentDate)
        }
    }

    let content: Content

    var body: some View {
        ViewThatFits {
            // Первый вариант: пытаемся разместить с максимальной шириной для количества дней
            makeContentView(maxWidth: true)
            // Второй вариант: если первый не помещается, используем фиксированную ширину
            makeContentView(maxWidth: false)
        }
    }

    @ViewBuilder
    private var colorTagView: some View {
        if let colorTag = content.colorTag {
            colorTag.frame(width: 16, height: 16)
                .clipShape(.circle)
        }
    }

    private var titleView: some View {
        Text(content.title)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var daysCountView: some View {
        Text(content.daysCount)
            .multilineTextAlignment(.trailing)
            .contentTransition(.numericText())
    }

    private func makeContentView(maxWidth: Bool) -> some View {
        HStack(spacing: 12) {
            colorTagView
            titleView
            if maxWidth {
                daysCountView
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                daysCountView
                    .containerRelativeFrame(.horizontal, alignment: .trailing) { length, _ in
                        length * 0.3
                    }
            }
        }
    }
}
