// import:
//	"github.com/charmbracelet/bubbles/textinput"

// in model:
// input         textinput.Model

ti := textinput.New()
ti.Placeholder = "Start typing to filter ..."
ti.Focus()
ti.CharLimit = 128

// in update:
// 	case tea.WindowSizeMsg:
// 		m.list.SetWidth(msg.Width)
// 		m.input.Width = msg.Width
//
// 	var cmd tea.Cmd
// 	m.input, cmd = m.input.Update(msg)
// 	return m, cmd

