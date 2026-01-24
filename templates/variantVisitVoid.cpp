std::visit(
    [](const auto &value) {
      using T = std::decay_t<decltype(value)>;
      if constexpr (std::is_same_v<T, FirstType>) {
        // do something with FirstType value
      } else if constexpr (std::is_same_v<T, SecondType>) {
        // do something with SecondType value
      }
    },
    item);
