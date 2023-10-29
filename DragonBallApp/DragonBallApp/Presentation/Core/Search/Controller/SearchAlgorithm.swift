//
//  SearchAlgorithm.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 24/10/23.
//

import Foundation

// MARK: - SearchAlgorithm -
final class SearchAlgorithm {
    
    // Función para calcular la similitud de Jaccard entre dos strings
    private static func jaccardSimilarity(_ s1: String, _ s2: String) -> Double {
        let set1 = Set(s1)
        let set2 = Set(s2)
        let intersection = set1.intersection(set2)
        let union = set1.union(set2)
        
        return Double(intersection.count) / Double(union.count)
    }

    // Función para encontrar todas las coincidencias cercanas en un array de strings usando la similitud de Jaccard
    private static func findNearestMatchesJaccard(input: String, options: Heroes) -> Heroes {
        var matches: Heroes = Heroes()
        let thresholdSimilarity: Double = 0.34
        
        for option in options {
            let similarity = jaccardSimilarity(input, option.name)
            if similarity >= thresholdSimilarity {
                matches.append(option)
            }
        }
        return matches
    }
    
    static func searchHeroesAlgorithm(heroes: Heroes, query: String) -> Heroes {
        let matches = findNearestMatchesJaccard(input: query.lowercased(), options: heroes.map { $0 })
        
        return matches
    }
}
