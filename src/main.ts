const main = async (...args: string[]) => {

};

if (import.meta.path == Bun.main) {
  await main(...process.argv.slice(2));
}
