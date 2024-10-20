import { getRandomJoke } from '../api/ChuckNorrisJokeApi'

@Entry
@Component
struct Index {
  @State message: string = 'Нажмите кнопку, чтобы загрузить шутку'
  @State isLoading: boolean = false

  build() {
    Column() {
      if (this.isLoading) {
        // ProgressBar().indeterminate(true).size('large').padding(20)
      } else {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding(20)
          .textAlign(TextAlign.Center)
          .flexGrow(1)
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
      })
  }
}