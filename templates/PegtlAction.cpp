template <> struct action<beat_text> {
  template <typename ActionInput>
  static void apply(const ActionInput &input, ParseState &state) {
    auto text = input.string();
    // Do something here
  }
};
