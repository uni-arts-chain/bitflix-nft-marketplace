import { store, Bytes, BigInt } from "@graphprotocol/graph-ts"

import {
  NewOffer,
  ItemBought,
  Marketplace,
} from "../generated/Marketplace/Marketplace"

import { MarketplaceOffer as MarketplaceOfferEntity } from '../generated/schema';


export function handleNewOffer(event: NewOffer): void {
  let offer = MarketplaceOfferEntity.load(event.params.offerId.toString())
  if(offer == null) {
    offer = new MarketplaceOfferEntity(event.params.offerId.toString())
  }
  let contract = Marketplace.bind(event.address)
  let offer_info = contract.getOffer(event.params.offerId)

  offer.item_id = offer_info.value0
  offer.price = offer_info.value1
  offer.seller = offer_info.value2
  offer.buyer = offer_info.value3
  offer.isOpen = offer_info.value4
  offer.save()
}

export function handleItemBought(event: ItemBought): void {
  let offer = MarketplaceOfferEntity.load(event.params.offerId.toString())
  if(offer == null) {
    return;
  }
  let contract = Marketplace.bind(event.address)
  let offer_info = contract.getOffer(event.params.offerId)
  // update offer
  offer.buyer = offer_info.value3
  offer.isOpen = offer_info.value4
  offer.save()
}