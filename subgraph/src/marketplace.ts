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
  let offer_info = contract.try_getOffer(event.params.offerId)

  offer.item_id = offer_info[0]
  offer.price = offer_info[1]
  offer.seller = offer_info[2]
  offer.buyer = offer_info[3]
  offer.isOpen = offer_info[4]
  offer.save()
}