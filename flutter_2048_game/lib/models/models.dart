import 'dart:math' show Random;

class Board {
  final int columm;
  final int row;
  int scores;

  Board(this.columm, this.row);

  List<List<Tile>> _boardTile;

  void initBoard() {
    _boardTile = List.generate(
      4,
      (r) => List.generate(
        4,
        (c) => Tile(
          row: r,
          column: c,
          value: 0,
          isNew: false,
          canMerge: false,
        ),
      ),
    );

    print(_boardTile);

    scores = 0;
    resetCanMerge();
    randomEmptyTile();
    randomEmptyTile();
  }

  void moveLeft() {
    if (!canMoveLeft()) return;
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < columm; ++c) {
        mergeLeft(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  void moveRight() {
    if (!canMoveRight()) return;
    for (int r = 0; r < row; ++r) {
      for (int c = columm - 2; c >= 0; --c) {
        mergeRight(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  void moveUp() {
    if (!canMoveUp()) return;
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < columm; ++c) {
        mergeUp(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  void moveDown() {
    if (!canMoveDown()) return;
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < columm; ++c) {
        mergeDown(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

//Left
  void mergeLeft(int row, int c) {
    while (c > 0) {
      merge(_boardTile[row][c], _boardTile[row][c - 1]);
      c--;
    }
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; ++r) {
      for (int c = 1; c < columm; ++c) {
        if (canMerge(_boardTile[r][c], _boardTile[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

//Right
  void mergeRight(int row, int c) {
    while (c < columm - 1) {
      merge(_boardTile[row][c], _boardTile[row][c + 1]);
      c++;
    }
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = columm - 2; c >= 0; --c) {
        if (canMerge(_boardTile[r][c], _boardTile[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

//Up

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(_boardTile[r][c], _boardTile[r - 1][c]);
      r--;
    }
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < columm; ++c) {
        if (canMerge(_boardTile[r][c], _boardTile[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

//Down

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      merge(_boardTile[r][c], _boardTile[r + 1][c]);
      r++;
    }
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < columm; ++c) {
        if (canMerge(_boardTile[r][c], _boardTile[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

//Merge

  bool canMerge(Tile a, Tile b) {
    return !a.canMerge &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void merge(Tile a, Tile b) {
    if (!canMerge(a, b)) {
      if (!a.isEmpty() && !b.canMerge) {
        b.canMerge = true;
      }
      return;
    }

    if (b.isEmpty()) {
      b.value = a.value;
      a.value = 0;
    } else if (a == b) {
      b.value = b.value * 2;
      a.value = 0;
      scores += b.value;
      b.canMerge = true;
    } else {
      b.canMerge = true;
    }
  }

  bool GameOver() {
    return !canMoveLeft() && !canMoveRight() && !canMoveUp() && !canMoveDown();
  }

  Tile getTile(int row, int column) {
    return _boardTile[row][column];
  }

  void randomEmptyTile() {
    // ignore: deprecated_member_use
    List<Tile> empty = List<Tile>();

    _boardTile.forEach((rows) {
      empty.addAll(rows.where((tile) => tile.isEmpty()));
    });
    if (empty.isEmpty) {
      return;
    }
    Random rand = Random();
    int index = rand.nextInt(empty.length);
    empty[index].value = rand.nextInt(9) == 0 ? 4 : 2;
    empty[index].isNew = true;
    empty.removeAt(index);
  }

  void resetCanMerge() {
    _boardTile.forEach((r) {
      r.forEach((tile) {
        tile.canMerge = false;
      });
    });
  }
}

class Tile {
  int row, column;
  int value;
  bool canMerge;
  bool isNew;
  Tile({this.row, this.column, this.value = 0, this.canMerge, this.isNew});

  bool isEmpty() {
    return value == 0;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  operator ==(other) {
    return other is Tile && value == other.value;
  }
}
