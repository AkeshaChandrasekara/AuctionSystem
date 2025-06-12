package com.auction.service;

import com.auction.entity.Auction;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

@Singleton
@Startup
public class AuctionService {
    private final List<Auction> auctions = new ArrayList<>();
    private final AtomicLong idGenerator = new AtomicLong(1);

    public AuctionService() {
        Date now = new Date();
        Date endTime1 = new Date(now.getTime() + TimeUnit.HOURS.toMillis(2));
        Date endTime2 = new Date(now.getTime() + TimeUnit.HOURS.toMillis(1));
        Date endTime3 = new Date(now.getTime() + TimeUnit.MINUTES.toMillis(10));

        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Art Nouveau Stained Glass Lamp",
                "A Tiffany-style lamp with colorful floral glass shades, early 20th century.",
                4500.0, now, endTime3, "images/vas2.jpg"));

        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Tiffany Studios Favrile Glass Vase",
                "An iridescent gold-and-peacock art glass vessel with organic ribbing, signed L.C.Tiffany - Favrile",
                5000.0, now, endTime3, "images/tf2.jpeg"));


        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Hand-Painted Ceramic Plate",
                "Colorful wall plate made in Italy with a traditional scene",
                4000.0, now, endTime3, "images/plate.jpg"));

        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Porcelain Tea Set",
                "Fine bone china tea set with floral patterns from the early 1900s.",
                10000.0, now, endTime2, "images/por.jpg"));


        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Victorian Taxidermy Butterfly Dome",
                "A glass-domed display of exotic butterflies arranged in a symmetrical pattern",
                3500.0, now, endTime2, "images/but.jpg"));

        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "18th-Century Shipbuilder's Model",
                "A detailed wooden scale model of a British naval frigate, complete with rigging and miniature cannons, used for shipyard planning.",
                6500.0, now, endTime2, "images/ship.jpg"));

        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Persian Handwoven Silk Rug",
                "A vibrant, richly colored rug with intricate geometric patterns, crafted in 19th-century Persia.",
                7000.0, now, endTime2, "images/nw.jpeg"));



        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Brass Oil Lamp",
                "An old brass lamp used in the 19th century with detailed carvings.",
                5500.0, now, endTime1, "images/brass.jpg"));

        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Rare Painting",
                "A hand-painted countryside scene in an ornate gold frame.",
                6000.0, now, endTime3, "images/painting.jpg"));



        auctions.add(new Auction(idGenerator.getAndIncrement(),
                "Art Deco Wall Clock",
                "A geometric-style wooden clock from the 1920s Art Deco period.",
                12000.0, now, endTime3, "images/cl.jpeg"));




    }

    public List<Auction> getAllAuctions() {
        return new ArrayList<>(auctions);
    }

    public Auction getAuctionById(Long id) {
        return auctions.stream()
                .filter(a -> a.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    public synchronized boolean placeBid(Long auctionId, String bidder, double amount) {
        Auction auction = getAuctionById(auctionId);
        if (auction == null || auction.getEndTime().before(new Date())) {
            return false;
        }

        if (amount > auction.getCurrentBid()) {
            auction.setCurrentBid(amount);
            auction.setHighestBidder(bidder);
            return true;
        }
        return false;
    }

    public synchronized void addAuction(Auction auction) {
        auctions.add(auction);
    }

    public synchronized void updateAuction(Auction updatedAuction) {
        for (int i = 0; i < auctions.size(); i++) {
            if (auctions.get(i).getId().equals(updatedAuction.getId())) {
                auctions.set(i, updatedAuction);
                break;
            }
        }
    }

    public synchronized void deleteAuction(Long id) {
        auctions.removeIf(a -> a.getId().equals(id));
    }

    public Long getNextId() {
        return idGenerator.getAndIncrement();
    }

}




