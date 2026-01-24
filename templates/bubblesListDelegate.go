// SECTION: List delegate
func (i SomeType) FilterValue() string { return i.Name }

type itemDelegate struct{}

func (d itemDelegate) Height() int                             { return 1 }
func (d itemDelegate) Spacing() int                            { return 0 }
func (d itemDelegate) Update(_ tea.Msg, _ *list.Model) tea.Cmd { return nil }
func (d itemDelegate) Render(w io.Writer, m list.Model, index int, listItem list.Item) {
	i, ok := listItem.(FoodItem)
	if !ok {
		return
	}

	str := fmt.Sprintf("%s", i.Name)

	fn := itemStyle.Render
	if index == m.Index() {
		fn = func(s ...string) string {
			return selectedItemStyle.Render("> " + strings.Join(s, " "))
		}
	}

	fmt.Fprint(w, fn(str))
}

//// List setup: ////
//	items := {some array of type SomeType}
//	allItems := make([]list.Item, len(items))
//	for i, item := range items {
//		allItems[i] = item
//	}
//
//  // Use this if you want the list height to be variable based on the number of items.
//  // the +4 handles padding
//	lh := min(len(items)+4, listHeight)
//
//	l := list.New(allItems, itemDelegate{}, defaultWidth, lh)
//	l.Title = "Some question or title"
//	l.SetShowStatusBar(false)
//	l.SetFilteringEnabled(false)
//	l.Styles.Title = titleStyle
//	l.Styles.PaginationStyle = paginationStyle
//	l.SetShowHelp(false)

