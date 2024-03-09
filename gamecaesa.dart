import 'dart:math';

int bossHealth = 3000;
int bossDamage = 50;
String? bossDefenceType;

List<int> heroesHealth = [300, 250, 200, 250, 200]; 
List<int> heroesDamage = [20, 25, 30, 30, 15]; 
List<String> heroesType = ["Berserk", "Magic", "TrickyBastard", "Deku", "Golem"]; 

int roundNumber = 0;
bool trickyBastardPlayingDead = false;

void main() {
  printStatic();

  while (!isGameFinish()) {
    playRound();
  }
}

void playRound() {
  roundNumber++;
  chooseBossDefence();
  bossHits();
  heroesHits();
  applySpecialAbilities();
  printStatic();
}

void chooseBossDefence() {
  bossDefenceType = heroesType[Random().nextInt(heroesType.length)];
}

bool isGameFinish() {
  if (bossHealth <= 0) {
    print("Победа героев!!");
    return true;
  }
  bool allHeroesDead = true;

  for (int health in heroesHealth) {
    if (health > 0) {
      allHeroesDead = false;
      break;
    }
  }
  if (allHeroesDead) {
    print("Победил Босс!!");
  }

  return allHeroesDead;
}

void bossHits() {
  for (int i = 0; i < heroesHealth.length; i++) {
    if (heroesHealth[i] > 0) {
      if (heroesType[i] == "Berserk") {
        int damageTaken = bossDamage ~/ 2;
        heroesHealth[i] -= damageTaken;

        int berserkDamage = heroesDamage[i] + bossDamage ~/ 4;
        bossHealth -= berserkDamage;

        if (bossHealth < 0) {
          bossHealth = 0;
        }
      } else if (heroesType[i] == "Golem") {
        int damageTaken = (bossDamage ~/ 5) * (heroesHealth.length - 1);
        heroesHealth[i] -= damageTaken;
      } else {
        heroesHealth[i] -= bossDamage;
        if (heroesHealth[i] < 0) {
          heroesHealth[i] = 0;
        }
      }
    }
  }
}

void heroesHits() {
  for (int i = 0; i < heroesHealth.length; i++) {
    if (bossHealth > 0 && heroesHealth[i] > 0) {
      int hit = heroesDamage[i];

      if (heroesType[i] == "Deku") {
        bool changeDamage = Random().nextBool();
        if (changeDamage) {
          int increasePercentage = [20, 50, 100][Random().nextInt(3)];
          int damageIncrease = (heroesDamage[i] * increasePercentage) ~/ 100;
          int healthLoss = (heroesHealth[i] * increasePercentage) ~/ 100;
          heroesDamage[i] += damageIncrease;
          heroesHealth[i] -= healthLoss;
          print("Deku усиливается на $increasePercentage%, но теряет $healthLoss HP");
        }
      }

      if (heroesType[i] == "TrickyBastard") {
        bool playDead = Random().nextBool();
        if (playDead) {
          trickyBastardPlayingDead = true;
          print("Tricky Bastard притворяется мертвым");
          heroesHealth[2] += bossDamage;
          heroesDamage[2] -= heroesDamage[2];
        }

        if (trickyBastardPlayingDead) {
          trickyBastardPlayingDead = false; 
         
          continue;
        }
      }

      if (bossDefenceType == heroesType[i]) {
        hit = (Random().nextInt(7) + 2) * heroesDamage[i];
        print("Критический урон: $hit");
      }

      
      bossHealth -= hit;

      if (heroesHealth[i] <= 0) {
        heroesHealth[i] = 0;
      }
    }
  }
}

void applySpecialAbilities() {
  if (roundNumber > 1) {
    for (int i = 0; i < heroesDamage.length; i++) {
      heroesDamage[i] += roundNumber * 3;
    }
  }
}

void printStatic() {
  print("Раунд $roundNumber -------------");
  print(
      "Здоровье Босса: $bossHealth Урон: $bossDamage Защита: ${bossDefenceType ?? "Отсутствует"}");

  for (int i = 0; i < heroesHealth.length; i++) {
    print(
        "Здоровье ${heroesType[i]}: ${heroesHealth[i]} Урон: ${heroesDamage[i]}");
  }
}