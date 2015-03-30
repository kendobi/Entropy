using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(ButtonClicker))]
[CanEditMultipleObjects]
// ReSharper disable once CheckNamespace
public class ButtonClickerInspector : Editor {
    private List<string> _groupNames;
    private bool _maInScene;
    private bool _isDirty;

    public override void OnInspectorGUI() {
        EditorGUIUtility.LookLikeControls();
        EditorGUI.indentLevel = 0;

        var ma = MasterAudio.Instance;
        _maInScene = ma != null;

        if (_maInScene) {
            DTGUIHelper.ShowHeaderTexture(MasterAudioInspectorResources.LogoTexture);
        }

        var sounds = (ButtonClicker)target;

        if (_maInScene) {
            // ReSharper disable once PossibleNullReferenceException
            _groupNames = ma.GroupNames;
        }

        var resizeOnClick = EditorGUILayout.Toggle("Resize On Click", sounds.resizeOnClick);

        if (resizeOnClick != sounds.resizeOnClick) {
            UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "change Resize On Click");
            sounds.resizeOnClick = resizeOnClick;
        }

        if (sounds.resizeOnClick) {
            EditorGUI.indentLevel = 1;
            var newResize = EditorGUILayout.Toggle("Resize All Siblings", sounds.resizeClickAllSiblings);
            if (newResize != sounds.resizeClickAllSiblings) {
                UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "Toggle Resize All Siblings");
                sounds.resizeClickAllSiblings = newResize;
            }
        }

        EditorGUI.indentLevel = 0;
        var resizeOnHover = EditorGUILayout.Toggle("Resize On Hover", sounds.resizeOnHover);

        if (resizeOnHover != sounds.resizeOnHover) {
            UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "change Resize On Hover");
            sounds.resizeOnHover = resizeOnHover;
        }

        if (sounds.resizeOnHover) {
            EditorGUI.indentLevel = 1;
            var newResize = EditorGUILayout.Toggle("Resize All Siblings", sounds.resizeHoverAllSiblings);
            if (newResize != sounds.resizeHoverAllSiblings) {
                UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "Toggle Resize All Siblings");
                sounds.resizeHoverAllSiblings = newResize;
            }
        }

        EditorGUI.indentLevel = 0;

        EditSoundGroup(sounds, ref sounds.mouseDownSound, "Mouse Down Sound");
        EditSoundGroup(sounds, ref sounds.mouseUpSound, "Mouse Up Sound");
        EditSoundGroup(sounds, ref sounds.mouseClickSound, "Mouse Click Sound");
        EditSoundGroup(sounds, ref sounds.mouseOverSound, "Mouse Over Sound");
        EditSoundGroup(sounds, ref sounds.mouseOutSound, "Mouse Out Sound");

        if (GUI.changed || _isDirty) {
            EditorUtility.SetDirty(target);
        }

        //DrawDefaultInspector();
    }

    void EditSoundGroup(ButtonClicker sounds, ref string soundGroup, string label) {
        DTGUIHelper.AddSpaceForNonU5(2);
        DTGUIHelper.StartGroupHeader();
        if (_maInScene) {
            var existingIndex = _groupNames.IndexOf(soundGroup);

            int? groupIndex = null;

            var noMatch = false;

            if (existingIndex >= 1) {
                groupIndex = EditorGUILayout.Popup(label, existingIndex, _groupNames.ToArray());
            } else if (existingIndex == -1 && soundGroup == MasterAudio.NoGroupName) {
                groupIndex = EditorGUILayout.Popup(label, existingIndex, _groupNames.ToArray());
            } else { // non-match
                noMatch = true;

                var newGroup = EditorGUILayout.TextField(label, soundGroup);
                if (newGroup != soundGroup) {
                    UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "change Sound Group");
                    soundGroup = newGroup;
                }
                var newIndex = EditorGUILayout.Popup("All Sound Types", -1, _groupNames.ToArray());
                if (newIndex >= 0) {
                    groupIndex = newIndex;
                }
            }

            if (noMatch) {
                DTGUIHelper.ShowRedError("Sound Type found no match. Choose one from 'All Sound Types'.");
            }

            if (!groupIndex.HasValue)
            {
                DTGUIHelper.EndGroupHeader();
                return;
            }

            if (existingIndex != groupIndex.Value) {
                UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "change Sound Group");
            }
            // ReSharper disable once ConvertIfStatementToConditionalTernaryExpression
            if (groupIndex.Value == -1) {
                soundGroup = MasterAudio.NoGroupName;
            } else {
                soundGroup = _groupNames[groupIndex.Value];
            }
        } else {
            var newGroup = EditorGUILayout.TextField(label, soundGroup);
            if (newGroup == soundGroup) {
                DTGUIHelper.EndGroupHeader();
                return;
            }

            soundGroup = newGroup;
            UndoHelper.RecordObjectPropertyForUndo(ref _isDirty, sounds, "change Sound Group");
        }
        DTGUIHelper.EndGroupHeader();
    }
}
