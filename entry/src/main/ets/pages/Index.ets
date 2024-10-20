import { getRandomJoke } from '../api/ChuckNorrisJokeApi'

const refreshTimerInterval = 300000

@Entry
@Component
struct Index {
  @State message: string = ""
  @State isLoading: boolean = false
  @State hasLoaded: boolean = false
  timerId: number | null = null

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress()
          .color(Color.Blue)
          .width("40%")
          .height("60%")
      } else {
        Text(this.message)
          .height("60%")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding(20)
          .textAlign(TextAlign.Center)
      }

      Button($r("app.string.updateJoke_button_label"))
        .onClick(() => {
          this.loadJoke()
        })
        .padding(10)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F0F0F0')
    .onAppear(() => {
      if (!this.hasLoaded) {
        this.loadJoke()
        this.hasLoaded = true
      }
    })
  }

  loadJoke() {
    this.isLoading = true
    this.message = ''

    getRandomJoke()
      .then(joke => {
        this.message = joke.value
      })
      .catch(error => {
        this.message = $r("app.string.can_not_load_joke_message") + ": " + error.message
      })
      .finally(() => {
        this.isLoading = false
        this.resetTimer()
      })
  }

  setTimer() {
    this.clearTimer()
    this.timerId = setTimeout(() => {
      this.loadJoke()
    }, refreshTimerInterval)
  }

  resetTimer() {
    this.setTimer()
  }

  clearTimer() {
    if (this.timerId !== null) {
      clearTimeout(this.timerId)
      this.timerId = null
    }
  }

  onDestroy() {
    this.clearTimer()
  }
}