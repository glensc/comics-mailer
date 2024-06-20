export class DeliveredState {
  private readonly state = new Set<string>();

  public constructor(
    private readonly savePath: string,
  ) {
  }

  public async load() {
    const file = Bun.file(this.savePath);
    if (!await file.exists()) {
      return;
    }

    const state = await file.json();
    for (const url of state) {
      this.state.add(url);
    }
  }

  public async store() {
    const state = [];
    for (const url of this.state) {
      state.push(url);
    }
    await Bun.write(this.savePath, JSON.stringify(state));
  }

  public has(url: string): boolean {
    return this.state.has(url);
  }

  public add(url: string) {
    this.state.add(url);
  }
}
