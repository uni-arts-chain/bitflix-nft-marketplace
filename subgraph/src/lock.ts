import { store, Bytes, BigInt } from "@graphprotocol/graph-ts"
import {
  Lock,
  Redeem
} from "../generated/BitflixPoint/BitflixPoint"

import { Lock as LockEntity } from '../generated/schema';


export function handleLock(event: Lock): void {
  let lock = LockEntity.load(event.params.id.toString())
  if(lock == null) {
    lock = new LockEntity(event.params.id.toString())
  }
  lock.user = event.params.user
  lock.startTime = event.block.timestamp
  lock.amount = event.params.amount
  lock.redeemed = false
  lock.save()
}

export function handleRedeem(event: Redeem): void {
  let lock = LockEntity.load(event.params.id.toString())
  lock.redeemed = true
  lock.save()
}
