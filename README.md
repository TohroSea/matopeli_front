# Matopelin frontend

### Idea:

- Mobiilissa toimiva klassikko matopeli, jossa toiminnallisuutena:
  > - Madon siirtymät swipe-eleillä.
  > - Pistelaskuri syödyille omenoille.
  > - Madon siirtymä näytön reunalta vastakkaiselle puolelle madon "törmätessä" reunaan.
  > - Peli nopeutuu hieman joka toisen syödyn omenan kohdalla
  > - Tulosten julkaisumahdollisuus Azuressa pyörivään sqlite tietokantaan ja paikalliseen tiedostoon haluamallaan käyttäjänimellä.
  > - Menuvalikko, jossa 'PLAY' näppäin pelin aloittamiseen ja 'HIGHSCORES' näppäin siirtymiselle tulos -valikkoon, josta löytyy lokaalit tulokset, sekä pilvessä olevat tulokset.
  >

---

## Hieman koodista:

- main.dart:

> Päätiedosto, käynnistää pelin ja sisältää perustoiminnallisuuden/logiikan. Vastuussa pelinäkymän näyttämisestä, sekä gameOver näkymän näyttämisestä, josta voidaan tulos lähettää Azureen/tallentaa lokaalisti.

- main_menu.dart:

> main:in kutsuma päävalikko, joka näytetään ensimmäisenä kun sovelluksen käynnistää. Näppäimet PLAY ja HIGHSCORES, joista voidaan joko aloittaa peli tai siirtyä tulos -valikkoon, josta löytyy lokaalit ja pilvessä olevat tulokset.

- highscores_screen.dart:

> Palauttaa tulos näkymän, joka tekee tulosten noutopyynnöt pilvestä ja lokaalista tiedostosta (käyttää siis push_and_fetch_score.dart ja local_storage.dart). Käyttää swipe-eleitä tabien välillä siirtymisessä.

- push_and_fetch_score.dart:

> Hoitaa tulosten lähettämisen ja noutamisen Azuren:sta.

- local_storage.dart:

> Toiminnallisuus tulosten tallentamiseen lokaalisti ja niiden noutamiseen shared_preferences riippuvuutta käyttäen.

---

#### Matopelin Backend

Löytyy täältä:

> https://github.com/TohroSea/matopeli_back

---

#### Devaukseen:

> Dartpad: https://dartpad.dev/
