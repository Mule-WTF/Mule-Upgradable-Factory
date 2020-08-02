const HDWallet = require('ethereum-hdwallet');
const bip39 = require('bip39');

async function create() {
  let mnemonic = 'drama goat among achieve pole jump host creek whip secret april pluck'
//  const mnemonic = await bip39.generateMnemonic();
  const seed = await bip39.mnemonicToSeed(mnemonic);
  console.log(mnemonic)
  const hdwallet = await HDWallet.fromSeed(seed)
  console.log(`0x${hdwallet.derive(`m/44'/60'/0'/0/0`).getAddress().toString('hex')}`)

  const hdwallet_check = HDWallet.fromMnemonic(mnemonic)
  console.log(`0x${hdwallet_check.derive(`m/44'/60'/0'/0/0`).getAddress().toString('hex')}`)

  console.log(hdwallet.derive(`m/44'/60'/0'/0/0`).getPrivateKey().toString('hex'))
}

create()
