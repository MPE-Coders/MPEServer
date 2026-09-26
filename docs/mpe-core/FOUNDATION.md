# MPE-Core: проверенный фундамент и следующие этапы

Дата: 2026-09-26. Это проектный документ, не новый релиз ядра. Существующий Docker-проект MPEServer не заменяется; main не изменяется этим документом до отдельного решения о merge.

## Проверенная исходная версия

MPE-Core 0.4.0-alpha.zip, SHA-256:
`44a9cd4a13fac75c65b2c513b8d23fc8e82153dc9123f250e43af02286ac4a90`.

MANIFEST.sha256 исходников:
`2cdec70f52fc27a9d78cdd6d41670094528fd80438a9d2b761385cb1a1848b29`.

Из архива подготовлены пять source-overlay пакетов и обратная сборка **177 файлов** с проверкой исходных SHA-256. Повторно пройдены **52 PHP, 25 JavaScript и 17 Python** unit-тестов исходного проекта. Инструмент разделения/сборки имеет ещё **15** пройденных тестов. Эти проверки не являются проверкой сетевого входа.

**Не выполнены:** Rust build, реальный engine IPC, установка всех настоящих сетевых зависимостей, сетевой E2E и проверка официальным Minecraft. `release_ready=false`. Код Pumpkin в эту версию не импортирован. Процент готовности ванили не вычислялся.

## Блокирующие места исходников

1. `src/block/mod.rs:2–5`: `BlockStateId = u8`, `BLOCK_COUNT = 12`. Поддерживаются 12 внутренних значений, включая воздух. Полные палитры нельзя добавить только новыми JSON-файлами. Нужен `StateId(u32)`, registry имён/типизированных свойств и компактная палитра секций.
2. `src/world/mod.rs:16,22,51,74`: `FlatGenerator` и независимо зашитое чтение «трава Y60..63, воздух иначе». Простая замена генератора даст несовпадение видимого рельефа с коллизиями/спавном. Нужен единый авторитетный ChunkProvider.
3. `src/world/mod.rs:91–97`: все непустые блоки считаются полным твёрдым кубом. Нет правильных форм плит/ступеней/дверей, растений, replaceability и жидкости.
4. `src/world/storage.rs:7–9,23–24,43–51`: MPEWAL02, 17-байтовая запись с u8 ID, предел 128 MiB, compaction отсутствует. Переход на новые ID требует явной миграции с backup, а не переинтерпретации старых байтов.
5. `gateway/src/network/mcpe/serializer/ChunkSerializer.php:7–18`: секция передаётся как 4096 байтов канонических ID; biome storage заполняется константой. Требуется обновить IPC и сериализацию совместно с моделью мира.
6. Есть Cargo.lock, но нет composer.lock и package-lock.json. Закрепление двух NetherGames-коммитов не фиксирует все транзитивные зависимости.

Rust уже имеет цикл 20 TPS, bounded input queue и одного владельца состояния; неверно считать его отсутствующим. Но региональной параллельной симуляции нет. Инвентарь в основном обслуживается PHP-шлюзом, поэтому будущие транзакции между движком и gateway требуют явно определённого владельца.

PHP-плагины имеют отдельный процесс и reload. Это не sandbox и не совместимость с любым PMMP PHAR. BlockChangeEvent приходит после фиксации изменения, поэтому не отменяет действие. Для отмены нужен pre-commit контракт с deadline и ясной политикой ошибки.

## Пакеты

| Планируемый репозиторий | Исходных файлов | Ответственность |
|---|---:|---|
| MPE-Coders/MPE-Core | 15 | Rust simulation, world, player state, IPC, persistence |
| MPE-Coders/MPE-Gateway | 76 | PHP/RakLib, auth, codecs, registries, текущий plugin host |
| MPE-Coders/MPE-PluginAPI | 9 | PluginBase, Player-фасад, Vector3, события, logger |
| MPE-Coders/MPE-TestClient | 15 | Headless-клиент и тесты |
| MPE-Coders/MPE-Server | 62 | Дистрибутив, start.sh, интеграционные тесты и инструменты |

Это подготовленные локальные **source-overlay** пакеты с metadata и хешами, пока не самостоятельные Cargo/Composer/npm библиотеки. `payload/` сохраняет оригинальные пути; сборщик восстанавливает исходную раскладку. Новые репозитории пока не созданы, SHA публикации в lock-файле не выдумываются. Названия MPEServer и MPE-Server намеренно различаются.

Следующий шаг после безопасного переноса — самостоятельные library/API границы, собственные версии и контрактные тесты. Версии IPC, Plugin API, формата мира, registry и Minecraft protocol независимы. Дистрибутив фиксирует точные выпуски и Git SHA компонентов, toolchain и lock-файлы.

MPE-WorldGen выделяется после появления настоящего адаптера, MPE-Content — после registry/behavior разделения. Существующие BedrockData/BedrockProtocol/PocketMine-MP forks не перезаписываются. Старый fork не становится актуальным upstream автоматически.

## Pumpkin: основной кандидат для world engine / worldgen

Проверен commit [003d3c49eaf1ca21207671be55a91587bc1330b5](https://github.com/Pumpkin-MC/Pumpkin/tree/003d3c49eaf1ca21207671be55a91587bc1330b5).

Конкретные источники:
- [Workspace и зависимости](https://github.com/Pumpkin-MC/Pumpkin/blob/003d3c49eaf1ca21207671be55a91587bc1330b5/Cargo.toml).
- [Generation entry point](https://github.com/Pumpkin-MC/Pumpkin/blob/003d3c49eaf1ca21207671be55a91587bc1330b5/crates/pumpkin-world/src/generation/mod.rs).
- [Generator/stage contracts](https://github.com/Pumpkin-MC/Pumpkin/blob/003d3c49eaf1ca21207671be55a91587bc1330b5/crates/pumpkin-world/src/generation/generator/mod.rs).
- [Границы чанков и возобновление структур: тесты](https://github.com/Pumpkin-MC/Pumpkin/blob/003d3c49eaf1ca21207671be55a91587bc1330b5/crates/pumpkin-world/src/generation/proto_chunk_test.rs).
- [World engine](https://docs.pumpkinmc.org/developer/world).
- [GPL-3.0](https://github.com/Pumpkin-MC/Pumpkin/blob/003d3c49eaf1ca21207671be55a91587bc1330b5/LICENSE).

В Pumpkin имеются стадии биомов, noise, surface, carvers, features, structures, соседние чанки, random splitters и registry-dependent BlockState. Это существенно полезнее самодельного Perlin-генератора, но не drop-in папка для MPE. Нужно адаптировать состояния, данные, стадии, сохранение и toolchain вместе. Имя VanillaGenerator не доказывает точность относительно официального Bedrock каждой версии.

Предварительный выбор: Pumpkin-backed vanilla-like generator за интерфейсом MPE-WorldGen. Подтвердить его небольшим компилируемым прототипом; если зависимость от остального движка слишком велика, сравнить с Bedrock-ориентированным форком большей части Pumpkin. Не менять одновременно gateway и генерацию без рабочего сетевого baseline. Не обещать превосходство в скорости без одинаковых тестов и оборудования.

**Критерий vanilla:** edition + точная версия генерации + seed + settings + dimensions. Сравнивать биомы, heightmaps, canonical-state hashes, пещеры/руды/структуры, block entities и loot. Проверять отрицательные координаты, границы чанков, порядок генерации и разное число потоков. Сохранять generator revision в мире. Runtime ID клиента не использовать как постоянный ID или основу межверсионного хеша.

[Cubiomes](https://github.com/Cubitect/cubiomes) полезен для биомов/seed, но не является полной готовой генерацией всех блоков и механик. Импорт собственных миров официального Minecraft/BDS — отдельный будущий способ получить точные уже сгенерированные чанки, а не реализация бесконечной генерации; Java Anvil и Bedrock LevelDB не взаимозаменяемы.

При копировании/адаптации Pumpkin соблюдать GPL, сохранять авторство и отмечать изменения; при распространении обеспечивать соответствующие исходники. Переименование или отдельный репозиторий не отменяют лицензию. Разделение по процессам не гарантирует автоматически независимость лицензий. В текущем комплекте Pumpkin-код не копировался.

## Этапы и критерии приёмки

### A. Проверенный сетевой фундамент

Чистая сборка Rust и зависимостей, IPC, настоящий E2E, online auth/encryption без секретов в логах, таймауты и лимиты пакетов/распаковки. Официальный клиент одной точной версии: вход, чанки, движение, chat, inventory, place/break, reconnect. CI-файл не равен выполненному CI. Результат официального теста записывать отдельно от unit-тестов.

### B. Registry, мир и сохранение

StateId(u32), typed states, palette storage, IPC v2, единый ChunkProvider, snapshots/WAL/compaction и player persistence. Миграция MPEWAL02 с backup. Приёмка: round-trip registry, high-cardinality sections, совпадение рельефа и collision, crash/restart recovery.

### C. Настоящий Creative-мультиплеер

Взаимная видимость игроков, skins, tracking, movement/equipment/metadata, одинаковые изменения мира, op/permissions/whitelist, time/weather/gamerules. Полный Creative-каталог выбранной версии с честной матрицей поведения. Приёмка: два официальных клиента, смена чанков, телепорты, reconnect, нет ghost blocks/dupes.

### D. Survival и обычная генерация

Крафт 2×2/верстак, shaped/shapeless recipes, печь/топливо, сундук, инструменты/прочность, дропы/pickup, здоровье/урон/голод/смерть/respawn, освещение и базовая физика блоков/жидкостей. Адаптированный генератор после сравнения эталонов. Приёмка: добыть дерево → инструмент → руду → переплавить → сохранить в сундуке → перезапустить без потери/дублирования.

### E. Дальнейшие механики

Мобы/AI/navigation/spawning, животные/размножение, villagers/POI/trades, redstone/pistons/order of updates, Nether/End/порталы/дракон, структуры/loot, enchant/brew/fishing/vehicles, custom entities/resource-pack compatibility, JS/WASM host, региональный scheduler. Эти функции не реализованы текущим архивом.

## Что означает полный набор блоков и предметов

Считать отдельно: **известно registry → сериализуется → отображается → взаимодействует → сохраняется → проверено клиентом**. JSON/NBT-таблица не заставляет печь плавить, песок падать, дверь открываться или провод передавать сигнал. Не реализованный блок нельзя молча объявлять ванильным полным кубом. Старому клиенту назначать native/custom/fallback/unsupported по его реальным возможностям; ресурс-пак не добавляет отсутствующие функции движка.

Цель ближайшего выпуска — доказанный игровой цикл на одной версии, затем registry/storage и проверяемый мультиплеер, а не увеличение числа профилей и смена номера архива.
