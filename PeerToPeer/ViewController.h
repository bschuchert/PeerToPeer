//
//  ViewController.h
//  PeerToPeer
//
//  Created by Bobby Schuchert on 1/27/13.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>

@property (nonatomic, strong) GKSession *session;
@property (nonatomic, strong) GKPeerPickerController *picker;
@property (nonatomic, strong) NSMutableArray *peers;

@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;

- (IBAction) connectToPeers:(id) sender;
- (IBAction) sendMessageButtonPressed:(id) sender;


@end
