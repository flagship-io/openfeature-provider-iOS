//
//  FSBucketCache.swift
//  FlagShip-framework
//
//  Created by Adel on 29/11/2019.
//

import Foundation
// Represent the object saved for each user

class FSBucketCache {
    var visitorId: String
    var campaigns: [FSCampaignCache]! // Refractor
    var extras: FSExtras?

    init(_ visitorId: String) {
        self.visitorId = visitorId
        self.campaigns = []
    }

    func getCampaignArray() -> [FSCampaign] {
        var result: [FSCampaign] = []

        if self.campaigns != nil {
            for item: FSCampaignCache in self.campaigns {
                let campaignResult = item.convertFSCampaignCachetoFSCampaign()

                if campaignResult.variation != nil {
                    result.append(campaignResult)
                }
            }
        }
        return result
    }
}

// Campaign contain liste variation groups
class FSCampaignCache {
    var campaignId: String = ""

    var nameCampaign: String = ""

    var type: String = ""

    var slug: String = ""

    var variationGroups: [FSVariationGroupCache]

    init(_ campaignId: String, _ campaignName: String, _ variationGroups: [FSVariationGroupCache], _ aType: String, _ aSlug: String) {
        self.campaignId = campaignId

        self.variationGroups = variationGroups

        self.nameCampaign = campaignName

        self.type = aType

        self.slug = aSlug
    }

    func convertFSCampaignCachetoFSCampaign() -> FSCampaign {
        let campaign = FSCampaign(campaignId, nameCampaign, self.variationGroups.first?.variationGroupId ?? "", self.variationGroups.first?.name ?? "", self.type, self.slug)
        campaign.variation = self.variationGroups.first?.getFSVariation()

        return campaign
    }
}

// Variation Groupe contain variation
class FSVariationGroupCache {
    var variationGroupId: String!

    var name: String = ""

    var variation: FSVariationCache!

    init(_ variationGroupId: String, _ nameVarGroup: String, _ variationCache: FSVariationCache) {
        self.variationGroupId = variationGroupId

        self.variation = variationCache

        self.name = nameVarGroup
    }

    func getFSVariation() -> FSVariation {
        return FSVariation(idVariation: self.variation.variationId, variationName: self.variation.variationName, self.variation.modification, isReference: self.variation.reference)
    }
}

// Variation
class FSVariationCache /*: Codable */ {
    var variationId: String = ""

    var variationName: String = ""

    var modification: FSModifications?

    var reference: Bool = false

    init(_ variationId: String) {
        self.variationId = variationId
    }
}
