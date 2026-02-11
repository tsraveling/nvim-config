return std::visit(
    [](const auto &value) -> InputType {
      using T = std::decay_t<decltype(value)>;
      if constexpr (std::is_same_v<T, Content>) {
        return InputType::CONTINUE;
      } else if constexpr (std::is_same_v<T, Query>) {
        return InputType::CONTINUE;
      } else if constexpr (std::is_same_v<T, Exit>) {
        return InputType::CONTINUE;
      } else if constexpr (std::is_same_v<T, GoModule>) {
        return InputType::CONTINUE;
      } else if constexpr (std::is_same_v<T, End>) {
        return InputType::CONTINUE;
      } else if constexpr (std::is_same_v<T, Error>) {
        return InputType::CONTINUE;
      }
    },
    response);
