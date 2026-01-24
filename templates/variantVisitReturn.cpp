std::string desc = std::visit(
    [](const auto &value) -> std::string {
      using T = std::decay_t<decltype(value)>;
      if constexpr (std::is_same_v<T, FirstType>) {
        return value.first_method();
      } else if constexpr (std::is_same_v<T, SecondType>) {
        return value.second_method();
      }
    },
    item);
