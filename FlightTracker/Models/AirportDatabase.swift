import Foundation

struct AirportDatabase {
    struct AirportInfo {
        let city: String
        let name: String
        let multiAirport: Bool
    }

    // swiftlint:disable:next large_tuple
    static let airports: [String: AirportInfo] = [
        // Russia
        "SVO": .init(city: "Москва", name: "Шереметьево", multiAirport: true),
        "DME": .init(city: "Москва", name: "Домодедово", multiAirport: true),
        "VKO": .init(city: "Москва", name: "Внуково", multiAirport: true),
        "ZIA": .init(city: "Москва", name: "Жуковский", multiAirport: true),
        "LED": .init(city: "Санкт-Петербург", name: "Пулково", multiAirport: false),
        "AER": .init(city: "Сочи", name: "Адлер", multiAirport: false),
        "KZN": .init(city: "Казань", name: "Казань", multiAirport: false),
        "UFA": .init(city: "Уфа", name: "Уфа", multiAirport: false),
        "SVX": .init(city: "Екатеринбург", name: "Кольцово", multiAirport: false),
        "OVB": .init(city: "Новосибирск", name: "Толмачёво", multiAirport: false),
        "KRR": .init(city: "Краснодар", name: "Пашковский", multiAirport: false),
        "ROV": .init(city: "Ростов-на-Дону", name: "Платов", multiAirport: false),
        "IKT": .init(city: "Иркутск", name: "Иркутск", multiAirport: false),
        "KHV": .init(city: "Хабаровск", name: "Новый", multiAirport: false),
        "VVO": .init(city: "Владивосток", name: "Кневичи", multiAirport: false),

        // UK
        "LHR": .init(city: "Лондон", name: "Heathrow", multiAirport: true),
        "LGW": .init(city: "Лондон", name: "Gatwick", multiAirport: true),
        "LCY": .init(city: "Лондон", name: "City", multiAirport: true),
        "STN": .init(city: "Лондон", name: "Stansted", multiAirport: true),
        "LTN": .init(city: "Лондон", name: "Luton", multiAirport: true),
        "MAN": .init(city: "Манчестер", name: "Manchester", multiAirport: false),
        "BHX": .init(city: "Бирмингем", name: "Birmingham", multiAirport: false),
        "EDI": .init(city: "Эдинбург", name: "Edinburgh", multiAirport: false),
        "GLA": .init(city: "Глазго", name: "Glasgow", multiAirport: false),

        // France
        "CDG": .init(city: "Париж", name: "Charles de Gaulle", multiAirport: true),
        "ORY": .init(city: "Париж", name: "Orly", multiAirport: true),
        "NCE": .init(city: "Ницца", name: "Côte d'Azur", multiAirport: false),
        "LYS": .init(city: "Лион", name: "Saint-Exupéry", multiAirport: false),
        "MRS": .init(city: "Марсель", name: "Provence", multiAirport: false),

        // Germany
        "FRA": .init(city: "Франкфурт", name: "Frankfurt", multiAirport: false),
        "MUC": .init(city: "Мюнхен", name: "Munich", multiAirport: false),
        "BER": .init(city: "Берлин", name: "Brandenburg", multiAirport: false),
        "DUS": .init(city: "Дюссельдорф", name: "Düsseldorf", multiAirport: false),
        "HAM": .init(city: "Гамбург", name: "Hamburg", multiAirport: false),
        "CGN": .init(city: "Кёльн", name: "Cologne Bonn", multiAirport: false),

        // Italy
        "FCO": .init(city: "Рим", name: "Fiumicino", multiAirport: true),
        "CIA": .init(city: "Рим", name: "Ciampino", multiAirport: true),
        "MXP": .init(city: "Милан", name: "Malpensa", multiAirport: true),
        "LIN": .init(city: "Милан", name: "Linate", multiAirport: true),
        "BGY": .init(city: "Милан", name: "Bergamo Orio", multiAirport: true),
        "VCE": .init(city: "Венеция", name: "Marco Polo", multiAirport: false),
        "NAP": .init(city: "Неаполь", name: "Capodichino", multiAirport: false),

        // Spain
        "MAD": .init(city: "Мадрид", name: "Barajas", multiAirport: false),
        "BCN": .init(city: "Барселона", name: "El Prat", multiAirport: false),
        "PMI": .init(city: "Пальма", name: "Son Sant Joan", multiAirport: false),
        "AGP": .init(city: "Малага", name: "Costa del Sol", multiAirport: false),
        "ALC": .init(city: "Аликанте", name: "El Altet", multiAirport: false),

        // Netherlands / Belgium / Switzerland / Austria
        "AMS": .init(city: "Амстердам", name: "Schiphol", multiAirport: false),
        "BRU": .init(city: "Брюссель", name: "Zaventem", multiAirport: false),
        "ZRH": .init(city: "Цюрих", name: "Zürich", multiAirport: false),
        "GVA": .init(city: "Женева", name: "Geneva", multiAirport: false),
        "VIE": .init(city: "Вена", name: "Vienna", multiAirport: false),

        // Turkey
        "IST": .init(city: "Стамбул", name: "Istanbul", multiAirport: true),
        "SAW": .init(city: "Стамбул", name: "Sabiha Gökçen", multiAirport: true),
        "AYT": .init(city: "Анталья", name: "Antalya", multiAirport: false),
        "ADB": .init(city: "Измир", name: "Adnan Menderes", multiAirport: false),
        "ESB": .init(city: "Анкара", name: "Esenboğa", multiAirport: false),

        // UAE / Middle East
        "DXB": .init(city: "Дубай", name: "Dubai International", multiAirport: true),
        "DWC": .init(city: "Дубай", name: "Al Maktoum", multiAirport: true),
        "AUH": .init(city: "Абу-Даби", name: "Abu Dhabi", multiAirport: false),
        "DOH": .init(city: "Доха", name: "Hamad", multiAirport: false),
        "BAH": .init(city: "Бахрейн", name: "Bahrain", multiAirport: false),

        // Asia
        "NRT": .init(city: "Токио", name: "Narita", multiAirport: true),
        "HND": .init(city: "Токио", name: "Haneda", multiAirport: true),
        "KIX": .init(city: "Осака", name: "Kansai", multiAirport: true),
        "ITM": .init(city: "Осака", name: "Itami", multiAirport: true),
        "ICN": .init(city: "Сеул", name: "Incheon", multiAirport: true),
        "GMP": .init(city: "Сеул", name: "Gimpo", multiAirport: true),
        "PEK": .init(city: "Пекин", name: "Capital", multiAirport: true),
        "PKX": .init(city: "Пекин", name: "Daxing", multiAirport: true),
        "PVG": .init(city: "Шанхай", name: "Pudong", multiAirport: true),
        "SHA": .init(city: "Шанхай", name: "Hongqiao", multiAirport: true),
        "HKG": .init(city: "Гонконг", name: "Hong Kong", multiAirport: false),
        "SIN": .init(city: "Сингапур", name: "Changi", multiAirport: false),
        "BKK": .init(city: "Бангкок", name: "Suvarnabhumi", multiAirport: true),
        "DMK": .init(city: "Бангкок", name: "Don Mueang", multiAirport: true),
        "KUL": .init(city: "Куала-Лумпур", name: "KLIA", multiAirport: false),
        "DEL": .init(city: "Дели", name: "Indira Gandhi", multiAirport: false),
        "BOM": .init(city: "Мумбаи", name: "Chhatrapati Shivaji", multiAirport: false),

        // USA
        "JFK": .init(city: "Нью-Йорк", name: "JFK", multiAirport: true),
        "LGA": .init(city: "Нью-Йорк", name: "LaGuardia", multiAirport: true),
        "EWR": .init(city: "Нью-Йорк", name: "Newark", multiAirport: true),
        "LAX": .init(city: "Лос-Анджелес", name: "LAX", multiAirport: false),
        "SFO": .init(city: "Сан-Франциско", name: "SFO", multiAirport: true),
        "OAK": .init(city: "Сан-Франциско", name: "Oakland", multiAirport: true),
        "SJC": .init(city: "Сан-Франциско", name: "San Jose", multiAirport: true),
        "ORD": .init(city: "Чикаго", name: "O'Hare", multiAirport: true),
        "MDW": .init(city: "Чикаго", name: "Midway", multiAirport: true),
        "DFW": .init(city: "Даллас", name: "Fort Worth", multiAirport: true),
        "DAL": .init(city: "Даллас", name: "Love Field", multiAirport: true),
        "MIA": .init(city: "Майами", name: "Miami", multiAirport: false),
        "ATL": .init(city: "Атланта", name: "Hartsfield-Jackson", multiAirport: false),
        "SEA": .init(city: "Сиэтл", name: "Sea-Tac", multiAirport: false),
        "BOS": .init(city: "Бостон", name: "Logan", multiAirport: false),
        "DCA": .init(city: "Вашингтон", name: "Reagan", multiAirport: true),
        "IAD": .init(city: "Вашингтон", name: "Dulles", multiAirport: true),
        "BWI": .init(city: "Вашингтон", name: "Baltimore", multiAirport: true),
        "LAS": .init(city: "Лас-Вегас", name: "Harry Reid", multiAirport: false),
        "PHX": .init(city: "Финикс", name: "Sky Harbor", multiAirport: false),
        "DEN": .init(city: "Денвер", name: "Denver", multiAirport: false),
        "MSP": .init(city: "Миннеаполис", name: "St. Paul", multiAirport: false),
        "DTW": .init(city: "Детройт", name: "Metro Wayne County", multiAirport: false),

        // Canada
        "YYZ": .init(city: "Торонто", name: "Pearson", multiAirport: true),
        "YTZ": .init(city: "Торонто", name: "Billy Bishop", multiAirport: true),
        "YVR": .init(city: "Ванкувер", name: "Vancouver", multiAirport: false),
        "YUL": .init(city: "Монреаль", name: "Trudeau", multiAirport: false),

        // Other
        "SYD": .init(city: "Сидней", name: "Kingsford Smith", multiAirport: false),
        "MEL": .init(city: "Мельбурн", name: "Tullamarine", multiAirport: false),
        "GRU": .init(city: "Сан-Паулу", name: "Guarulhos", multiAirport: true),
        "CGH": .init(city: "Сан-Паулу", name: "Congonhas", multiAirport: true),
        "GIG": .init(city: "Рио-де-Жанейро", name: "Galeão", multiAirport: true),
        "SDU": .init(city: "Рио-де-Жанейро", name: "Santos Dumont", multiAirport: true),
        "JNB": .init(city: "Йоханнесбург", name: "O.R. Tambo", multiAirport: false),
        "CAI": .init(city: "Каир", name: "Cairo", multiAirport: false),
    ]

    /// Display name: "Москва • Шереметьево" for multi-airport cities, just "Москва" for single
    static func displayName(for iata: String) -> String {
        guard let info = airports[iata] else { return iata }
        return info.multiAirport ? "\(info.city) • \(info.name)" : info.city
    }

    static func city(for iata: String) -> String {
        airports[iata]?.city ?? iata
    }

    static func airportName(for iata: String) -> String {
        airports[iata]?.name ?? iata
    }
}
