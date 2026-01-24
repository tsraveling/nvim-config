sem := make(chan struct{}, maxWorkers) // <- define this
var wg sync.WaitGroup

for i, stuff := range batches {
	wg.Add(1)
	sem <- struct{}{} // This uses zero memory

	go func(id int, stuff stuff) {
		defer wg.Done()
		defer func() { <-sem }()

		// For bTea
		program.Send(startedWorkMsg{id: id})

		// Your actual work
		doSomethingExpensive(stuff)

		program.Send(finishedWorkMsg{id: id})
	}(i, images)
}

wg.Wait()
