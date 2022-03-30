// https://doc.qt.io/qt-5/qtqml-javascript-resources.html
.pragma library

.import 'cryptodata.js' as Data

const currencies = Data.currencies

function getCurrencySymbol(id) {
  let id2 = id.toLowerCase()
  let rets = currencies[id2].symbol
  return rets
}
