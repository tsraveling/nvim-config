#include "SomeScene.h"
#include "drawing/Color.h"
#include "scenes/core/SceneManager.h"

SomeScene::SomeScene(SceneManager *m) : Scene(m), draw(m->get_renderer()) {

  // Assign the manager
  mgr = m;

  // Grab the keyboard and mouse
  kb = &mgr->kb;
  mouse = &mgr->mouse;

  // Add a camera
  // draw.make_camera(-350, -50);
}

void SomeScene::enter() {}
void SomeScene::handle_event(const SDL_Event &event) {}
void SomeScene::main(float delta) {
  draw.set_color(Colors::WHITE);
  draw.dbg_print(50, 50, "Hello, world!");
}
void SomeScene::cleanup() {}
