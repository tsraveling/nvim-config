func walkFiles(path string) {
	filepath.WalkDir(path, func(p string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.IsDir() && strings.HasSuffix(strings.ToLower(d.Name()), ".png") {
			fmt.Println(p)
		}
		return nil
	})
}

