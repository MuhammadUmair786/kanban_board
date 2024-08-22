import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class GoogleAuth {
  Map<String, String>? _authHeaders;
  Client? client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    DriveApi.driveFileScope,
    DriveApi.driveAppdataScope,
  ]);

  GoogleAuth() : super() {
    _initLoginListener();
  }

  // Future<OAuthCredential?> getCredential() async {
  Future<void> getCredential() async {
    GoogleSignInAccount? googleAccount;

    if (_googleSignIn.currentUser == null) {
      googleAccount = await _googleSignIn.signInSilently();
      if (_googleSignIn.currentUser == null) {
        googleAccount = await _googleSignIn.signIn();
      }
    }
    if (googleAccount == null) {
      // return null;
      return;
    }
    // final authentication = await googleAccount.authentication;
    // final OAuthCredential credential = GoogleAuthProvider.credential(
    //     idToken: authentication.idToken,
    //     accessToken: authentication.accessToken);
    // return credential;
  }

  _initLoginListener() {
    _googleSignIn.onCurrentUserChanged.listen((account) async {
      if (account == null) {
        if (kDebugMode) {
          print('not login');
        }
        _clearData();
      } else {
        if (kDebugMode) {
          print('login : $account');
        }
      }
    });
    _googleSignIn.signInSilently();
  }

  _clearData() {
    _authHeaders = null;
    client = null;
  }

  _setClient() {
    if (_authHeaders != null) {
      client = GoogleApiClient(_authHeaders!);
    }
  }

  _setHeaderWithAccessToken() async {
    _authHeaders = await _googleSignIn.currentUser!.authHeaders;
  }

  // Future<OAuthCredential?> login() async {
  Future<void> login() async {
    // final credential = await getCredential();
    await getCredential();
    await _setHeaderWithAccessToken();
    await _setClient();
    // return credential;
  }

  logout() async {
    await _googleSignIn.signOut();
    // await setUid(null);
  }
}

class GoogleApiClient extends IOClient {
  late final Map<String, String> _authHeaders;
  GoogleApiClient(this._authHeaders) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) {
    return super.send(request..headers.addAll(_authHeaders));
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    return super.head(url,
        headers: headers ?? {}
          ..addAll(_authHeaders));
  }
}
