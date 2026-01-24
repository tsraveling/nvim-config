package main

import (
	tea "github.com/charmbracelet/bubbletea"
)

func main() {

	// Load the config file
	cfg = readConfig()

	var m tea.Model
	m, _ = makeSomeModel()

	p := tea.NewProgram(m)
	p.Run()
}
