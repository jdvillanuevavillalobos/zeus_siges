/**
 * Entidad para manejar temas.
 */
export class Theme {
  constructor(name, backgroundColor, textColor) {
    this.name = name;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
  }

  static LIGHT = new Theme('light', 'white', 'black');
  static DARK = new Theme('dark', 'black', 'white');
}
