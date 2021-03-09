/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import JailMonkey from 'jail-monkey';
import React, { useEffect, useState } from 'react';
import { Alert, Button, Platform, StyleSheet, Text, View } from 'react-native';
import RNExitApp from 'react-native-exit-app';

const URL = 'https://medium.com'

const App: () => React$Node = () => {
  const [validationMsg, setValidationMsg] = useState('Waiting')
  const [validationStatus, setValidationStatus] = useState('')
  const onConnectPress = () => {
    fetch(URL)
      .then((res) => {
        console.log('**************')
        console.log(res)
        console.log('**************')
        setValidationMsg('Valid certificate, connected.')
        setValidationStatus('success')
      })
      .catch(() => {
        setValidationMsg('Certificate does not match, connection refused')
        setValidationStatus('failed')
      })
  }

  useEffect(() => {
    if (Platform.OS == 'android' && JailMonkey.isJailBroken()) {
      return Alert.alert(
        'Root Device is Detected',
        'You cannot use this app, bye 👋',
        [
          {
            text: 'Ok',
            onPress: () => RNExitApp.exitApp(),
          },
        ]
      );
    }
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>React Native SSL Pinning</Text>
      <Text style={styles.title}>({Platform.OS.toUpperCase()})</Text>
      <Text style={styles.header}>Certificate status:</Text>
      <Text
        style={[
          styles.status,
          validationStatus === 'success' && styles.success,
          validationStatus === 'failed' && styles.failed,
        ]}>
        {validationMsg}
      </Text>
      <View style={styles.btnContainer}>
        <Button title={`Test ${URL}`} onPress={onConnectPress} />
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  header: {
    paddingTop: 46,
    fontSize: 18,
    textAlign: 'center',
  },
  status: {
    fontSize: 18,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  success: {
    fontSize: 18,
    fontWeight: 'bold',
    color: 'green',
  },
  failed: {
    fontSize: 18,
    fontWeight: 'bold',
    color: 'red',
  },
  btnContainer: {
    borderWidth: 1,
    borderColor: 'grey',
    borderRadius: 4,
    paddingHorizontal: 16,
    marginTop: 24,
  },
})

export default App
