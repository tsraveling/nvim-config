type workProgressMsg struct {
	int someData
}

type workCompleteMsg struct{}

func workerCmd(path string) tea.Cmd {
	return func() tea.Msg {
		for i := 0; i < 50; i++ {
			time.Sleep(100 * time.Millisecond)
			prg.Send(workProgressMsg{i})
		}
		return workCompleteMsg{}
	}
}

