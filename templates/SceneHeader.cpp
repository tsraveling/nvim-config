#pragma once

#include "drawing/Drawing.h"
#include "input/Mouse.h"
#include "scenes/core/Scene.h"

class SomeScene : public Scene {
public:
  SomeScene(SceneManager *m);
  void enter() override;
  void handle_event(const SDL_Event &event) override;
  void main(float delta) override;
  void cleanup() override;

private:
  Draw draw;
  Keyboard *kb;
  Mouse *mouse;
};
