//
//  ViewController.m
//  PeerToPeer
//
//  Created by Bobby Schuchert on 1/27/13.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _picker = [[GKPeerPickerController alloc] init];
    _picker.delegate = self;
    
    //There are 2 modes of connection type
    // - GKPeerPickerConnectionTypeNearby via BlueTooth
    // - GKPeerPickerConnectionTypeOnline via Internet
    // We will use Bluetooth Connectivity for this example
    
    _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    _peers=[[NSMutableArray alloc] init];
    
    _connectButton.hidden = NO;
    _sendMessageButton.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Connect to other peers by displayign the GKPeerPicker
- (IBAction) connectToPeers:(id) sender {
    [_picker show];
}


#pragma mark - Message Entry Alertview
- (IBAction)sendMessageButtonPressed:(id)sender {
    UIAlertView *messageEntry = [[UIAlertView alloc] initWithTitle:@"Enter Message Text"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Send", nil];
    [messageEntry setDelegate:self];
    [messageEntry setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [messageEntry show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Send"])
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *message = textField.text;
        [_session sendData:[message dataUsingEncoding: NSNonLossyASCIIStringEncoding] toPeers:_peers withDataMode:GKSendDataReliable error:nil];
        
    }
}



#pragma mark - GKPeerPickerControllerDelegate

// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    // Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
    GKSession* session = [[GKSession alloc] initWithSessionID:@"com.mycompany.peertopeer" displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    
    // Get the session and assign it locally
    _session = session;
    _session.delegate = self;
    
    //dismiss the picker
    _picker.delegate = nil;
    [_picker dismiss];
}

// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    //Convert received NSData to NSString to display
    NSString *incomingMessage = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    //Display the message as a UIAlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Received" message:incomingMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
    if(state == GKPeerStateConnected){
        
        // Add the peer to the Array
        [_peers addObject:peerID];
        
        NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        // Used to acknowledge that we will be sending data
        [session setDataReceiveHandler:self withContext:nil];
    
        _connectButton.hidden = YES;
        _sendMessageButton.hidden = NO;
        
    }
    
}


@end
